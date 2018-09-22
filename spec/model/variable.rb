# Handles a single study variable
#
# @author Dave Iberson-Hurst
# @since 0.0.1
# @!attribute short_name
#   @return [String] the short name of the variable (the eight character name)
# @!attribute name
#   @return [String] the full long name of the variable
# @!attribute ordinal
#   @return [String] the ordinal of the variable within the parent domain
# @!attribute user
#   @return [Boolean] true if a user defined variable (supp qualifier)
# @!attribute core
#   @return [Enum] the SDTM core satus of the variable, :required, :permissible or :expected
# @!attribute previous_used
#   @return [Boolean] ???
# @!attribute controlled_term_or_format
#   @return [Boolean] The CT reference or format to be used
# @!attribute datatype
#   @return [String] The datatype
class Study::Variable < Study::Base

	C_CLASS_NAME = "Study::Variable"

	include ErrorsUtility
	include Neo4jUtility

	property :short_name, type: String
	property :name, type: String
	property :ordinal, type: Integer
	property :user, type: Boolean
	enum core: [:required, :permissible, :expected]
	property :previous_used, type: Boolean
	property :controlled_term_or_format, type: String
	property :datatype, type: String
  property :role, type: String

  validates :short_name, :presence => true
  validates :name, :presence => true
  validates :ordinal, :presence => true
  validates :core, :presence => true
  validates_inclusion_of :user, :in => [true, false]
  validates_inclusion_of :previous_used, :in => [true, false]
  validates :role, :presence => true
  
  has_one :out, :based_on, type: :IS_A, model_class: "Mdr::Variable"
  has_one :out, :comment_used, type: :HAS_COMMENT, model_class: "Mdr::Comment"
  has_one :out, :derivation_used, type: :HAS_DERIVATION, model_class: "Mdr::Derivation"
  
  @@core_map = {required: 0, permissible: 1, expected: 2}

  def self.core_db(value)
    return @@core_map[value]
  end

  # Construct
	#
	# @param params [Hash] hash of parameters
	# @option short_name [String] the short name
	# @option name [String] the long name
	# @option ordinal [Boolean] the ordinal within the variable collection
	# @option user [Boolean] the variable is user defined 
	# @option used [Boolean] the variable is used
	# @option params [Boolean] :used flag indicating the item is in use
  # @option params [String] :version_uuid the uuid for the parent version class/node
  # @raise Errors::CreateError if errors occur during the create
  # @return [Study::Variable] the object created if no errors.
	def self.construct(params, variable)
		object = super(params)
    object.based_on = variable
    return object
  end

  def value_level
  	results = []
  	# BC VLM
  	query = %Q{
MATCH (bc:`Mdr::BiomedicalConcept`)-[*1..5]->(bcp1:`Mdr::BiomedicalConcept::PropertyX`)<-[:IS_A]-(sfp:`Study::Form::BcProperty`)
	-[:SDTM_TARGET]->(sv:`Study::Variable` {uuid: '#{self.id}'})
WITH sfp, sv, bc, bcp1 
OPTIONAL MATCH (bcp1)-[:HAS_TC]->(t2:`Mdr::ThesaurusConcept`) 
WITH sfp, sv, bc, bcp1, t2 
MATCH (sfp)-[:SDTM_TARGET]->(sv)-[:IS_A]->(mv1:`Mdr::Variable`)-[:HAS_VARIANT]->(var:`Mdr::Variant`)-[:HAS_CONDITION]->(mv2:`Mdr::Variable`) 
	<-[:SDTM_TARGET]-(bcp2:`Mdr::BiomedicalConcept::PropertyX`)-[:HAS_TC]->(t:`Mdr::ThesaurusConcept`) 
WITH sfp, sv, bc, bcp1, mv1, var, mv2, bcp2, t, t2
MATCH (bc)-[*1..5]->(bcp2) 
RETURN sfp.uuid as key, sv.short_name as name, bcp1.field_format as format, bcp1.simple_datatype as simple_datatype, 
	t2.notation as term, mv2.name as condition_name, t.notation as value
		}
		neo4j_session = Neo4j::ActiveBase.current_session
		bc_results = neo4j_session.query(query)
		# Non BC (Question and Define Sourced) VLM
		query = %Q{
MATCH (svar:`Study::Variant`)-[:SDTM_TARGET]->(sv1:`Study::Variable` {uuid: '#{self.id}'})-[:IS_A]->(mv1:`Mdr::Variable`)-[]->
  (mvar:`Mdr::Variant`)-[]->(mv2:`Mdr::Variable`)<-[:IS_A]-(sv2:`Study::Variable`)<-[:SDTM_TARGET]-(c:`Study::Condition`)
WHERE (svar)-[:HAS_CONDITION]->(c) OR (c)<-[:HAS_CONDITION]-()<-[:HAS_MAPPING]-()-[:HAS_QUESTION]->(svar)
OPTIONAL MATCH (c)-[:HAS_TC]->(tc1)
OPTIONAL MATCH (svar)-[:HAS_TC]->(tc2)
RETURN DISTINCT svar.uuid as key, sv1.short_name as name, svar.field_format as format, svar.simple_datatype as simple_datatype, 
  tc2.notation as term, sv2.short_name as condition_name, tc1.notation as value
}
		neo4j_session = Neo4j::ActiveBase.current_session
		q_results = neo4j_session.query(query)
		results = []
		grouped_bc = bc_results.group_by{|x| { key: x["key"], conditions: [ {condition_name: x["condition_name"] , value: x["value"]} ]}}
		grouped_q = q_results.group_by{|x| { key: x["key"], conditions: [ {condition_name: x["condition_name"] , value: x["value"]} ]}}
		grouped = grouped_bc.merge(grouped_q)
		grouped.each do |key, formats|
			key[:formats] = []
			formats.each do |a|
				format = a.to_h
				format.slice!(:name, :format, :simple_datatype, :term)
				key[:formats] << format
			end
      key[:conditions].delete_if { |x| x[:condition_name].nil? } # Delete any nil conditions. Will occur when no A when X=Y type annotations
			results << key
		end
		return results
	end
	
	def terminology
  	results = []
  	# BC two parts and question third part.
  	query = %Q{
  		MATCH (sfp:`Study::Form::BcProperty`)-[r1:SDTM_TARGET]->(sv:`Study::Variable` {uuid: '#{self.id}'}) 
			WITH sfp, sv 
			MATCH (sfp)-[r2:HAS_TC]->(t:`Mdr::ThesaurusConcept`) 
			RETURN DISTINCT t.identifier as identifier, t.notation as notation, t.preferred_term as preferred_term, t.definition as definition, 
				t.synonyms as synonyms
			UNION
			MATCH (sv1:`Study::Variable` {uuid: '#{self.id}'})<-[:HAS_VARIABLE]-(sd:`Study::Domain`)-[:HAS_VARIABLE]->(sv2:`Study::Variable`)
        <-[:SDTM_TARGET]-(sfp:`Study::Form::BcProperty`)<-[:HAS_PROPERTY]-(sfng:`Study::Form::NormalGroup`)-[:IS_A]->(bc:`Mdr::BiomedicalConcept`)
        -[*1..5]->(p:`Mdr::BiomedicalConcept::PropertyX` {leaf: true})-[:SDTM_TARGET]->(mv1:`Mdr::Variable`)
        WHERE (sv1)-[:IS_A]->(mv1)
				WITH p, sv1, sd, sv2, sfp, sfng, bc, mv1
				MATCH (p)-[t2:HAS_TC]->(t:`Mdr::ThesaurusConcept`)
				RETURN DISTINCT t.identifier as identifier, t.notation as notation, t.preferred_term as preferred_term, 
					t.definition as definition, t.synonyms as synonyms
			UNION
			MATCH (t:`Mdr::ThesaurusConcept`)<-[r1:HAS_TC]-()-[r2:SDTM_TARGET]->(sv:`Study::Variable` {uuid: '#{self.id}'}) 
			RETURN t.identifier as identifier, t.notation as notation, t.preferred_term as preferred_term, t.definition as definition, 
				t.synonyms as synonyms
		}
		neo4j_session = Neo4j::ActiveBase.current_session
		neo4j_session.query(query).each { |x| results << x.to_h }
		return results
	end
	
	# Origin
	#
	# @return [String] the origin for the variable
	def origin
		query = "OPTIONAL MATCH (`Study::Variable` {uuid: '#{self.id}'})<-[:SDTM_TARGET]-(p) " +
			"WITH p " +
			"OPTIONAL MATCH (d:`Mdr::Derivation`)<-[:HAS_DERIVATION]-(`Study::Variable` {uuid: '#{self.id}'}) " +
			"RETURN DISTINCT " +
			"CASE " +
			"WHEN p IS NULL AND d IS NULL THEN 'Assigned' " +
			"WHEN p IS NULL THEN 'Derived' " +
			"ELSE 'CRF' END  " +
			"AS origin"
		neo4j_session = Neo4j::ActiveBase.current_session
		results = neo4j_session.query(query)
		return results.first["origin"]
	end

  # Terminology Editable?
  #
  # @return [Boolean] true if the terminology can be edited, false otherwise.
  def terminology_editable?
    query_text = %Q{RETURN EXISTS((:`Study::Source`)-[:SDTM_TARGET]->(:`Study::Variable` {uuid: '#{self.id}'}))}
    results = query(query_text)
    return results.rows[0][0]
  end

  def key_position
		return ""
	end

	def length
		return ""
	end
	
  def comment?
  	return comment_used.nil? ? false : true
  end

  def comments?
  	return self.based_on.comments.count == 0 ? false : true
  end

  def comment
  	return self.comment_used
  end

  def comments_bar
  	results = []
  	current = self.comment_used
  	comments = self.based_on.comments
  	comments.each { |x| results << x } # Needed to do this because of changing result retunred by above.
  	results.delete_if { |h| h.id == current.id } if !current.nil?
  	return results
  end

  def comment_text
  	return "" if self.comment_used.nil?
  	return self.comment_used.comment
  end

  def update_comment(id)
  	self.comment_used = Mdr::Comment.find(id)
  end

  def remove_comment
  	self.comment_used = nil
  end

  def derivation?
  	return derivation_used.nil? ? false : true
  end

  def derivations?
  	return self.based_on.derivations.count == 0 ? false : true
  end

  def derivation
  	return self.derivation_used
  end

  def derivations_bar
  	results = []
  	current = self.derivation_used
  	derivations = self.based_on.derivations
  	derivations.each { |x| results << x } # Needed to do this because of changing result retunred by above.
  	results.delete_if { |h| h.id == current.id } if !current.nil?
  	return results
  end

  def derivation_text
  	return "" if self.derivation_used.nil?
  	return self.derivation_used.description
  end

  def update_derivation(id)
  	self.derivation_used = Mdr::Derivation.find(id)
  end

  def remove_derivation
  	self.derivation_used = nil
  end

  # Toggle used
	#
	# @return [Null] nothing returned
	def toggle
		self.used = !self.used
		if !save
			update_error(__method__.to_s)
		end
		return self
	end

  # Set Used
	#
	# @return [Null] nothing returned
	def set_used
		self.used = true
		if !save
			update_error(__method__.to_s)
		end
		return self
	end

  def study_version
  	result = nil
		query = "(n:`Study::Version`) --> (`Study::SdtmIg`) --> (`Study::Domain`) --> (`Study::Variable` {uuid: '#{self.id}' })"
    version = Study::Version.query_as(:n).match(query).pluck(:n)
    if version.count == 1
    	result = version[0]
    else
    	Errors.application_error(C_CLASS_NAME, __method__.to_s, "Unable to find study_version.")
    end
    return result
  end

  def parent
  	query = "(n:`Study::Domain`) --> (`Study::Variable` {uuid: '#{self.id}' })"
    domain = Study::Domain.query_as(:n).match(query).pluck(:n)
    return domain.first if domain.count == 1
    Errors.application_error(C_CLASS_NAME, __method__.to_s, "Unable to find parent.")
  end

  def source
    query = "(n:`Study::Source`)-[:SDTM_TARGET]->(`Study::Variable` {uuid: '#{self.id}' })"
    source = Study::Source.query_as(:n).match(query).pluck(:n)
    return source.first if source.count == 1
    Errors.application_error(C_CLASS_NAME, __method__.to_s, "Unable to find source.")
  end

  def delete
		self.destroy
  end

  def mandatory
  	return "Yes" if core == :required
  	return "No"
  end

  def default_comment_and_derivation
		results = []
		query = %Q{
			MATCH (sv:`Study::Variable` {uuid: '#{self.id}'})-[IS_A]->(mv:`Mdr::Variable`)
			WITH sv,mv
			MATCH (mv)-[r1:HAS_COMMENT]->(c:`Mdr::Comment`)
            WHERE r1.default = true
			CREATE (sv)-[:HAS_COMMENT]->(c)
			WITH sv,mv
			MATCH (mv)-[r2:HAS_DERIVATION]->(d:`Mdr::Derivation`)
			WHERE r2.default = true
			CREATE (sv)-[:HAS_DERIVATION]->(d)		
		}
	  neo4j_session = Neo4j::ActiveBase.current_session
    values = neo4j_session.query(query)
  end

  def clone(version_uuid)
    object = super
    object.based_on = self.based_on
    object.comment_used = self.comment_used
    object.derivation_used = self.derivation_used
    return object
  end

  def vlm_oid
    return "#{self.id}-vlm"
  end

end
