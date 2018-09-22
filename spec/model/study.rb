# Study Class. Manages a study and the constituent versions
#
# @author Dave Iberson-Hurst
# @since 0.0.1
# @!attribute identifier
#   @return [String] the study identifier
# @!attribute name
#   @return [String] the study name
# @!attribute source
#   @return [Symbol] the source for building the define, either 
#   :mdr for building with no source info, 
#   :study_build for using a study build file, or 
#   :define for building from a define file.
# @!attribute study_id
#   @return [String] the identifier of the study being used in the study build tool. Only used for :source = :study_build
# @!attribute study_version_id
#   @return [String] the identifier of the study version being used in the study build tool. Only used for :source = :study_build
# @!attribute filename
#   @return [String] the name of the file used tobuild the study. Only used for :source = :define
class Study

	include Neo4j::ActiveNode
	include HashExtension

  property :identifier, type: String
	property :name, type: String # Don't use label given Neo4j significance.
	enum source: [ :mdr, :define ]
  property :filename, type: String

  validates :identifier, :presence => true, uniqueness: true, format: { with: /\A[a-zA-Z0-9 ]+\z/ }
  validates :name, :presence => true
	validates :source, :presence => true
  validates :filename, :presence => true, :if => :define? # Note define? method a consequence of the enum declaration.
  
  has_many :out, :study_versions, type: :HAS_VERSION, model_class: "Study::Version"

  C_CLASS_NAME = self.name

  # Construct
	#
	# @param params [Hash] hash of parameters
	# @option name [String] the item's name
	# @option identifier [String] the item's identifier
	# @option source [Symbol] the initial source of the study build when created
	# @option filename [String] the filename for building from a define file (for source = :define)
  # @raise Errors::CreateError if create fails
  # @return [Study] the reference object if no exception raised
	def self.construct(params)
  	params[:filename] ||= ""
    params[:source] ||= ""
    object = Study.create(params)
  	Errors.object_create_error(C_CLASS_NAME, __method__.to_s, object) if !object.errors.empty?
    object.initial_version
    return object
  end

  # Initial Version. Sets the study initial version.
	#
	# @raise Errors::CreateError if add fails, propogates from Study::Version
  # @return [Study::Version] the created object if no exception raised
	def initial_version
		params = self.to_hash
		params.slice!(:name, :identifier) # Just pass in name and identifier, strip others out.
  	study_version = Study::Version.construct(params, self)
  	self.study_versions << study_version
  	return study_version
  end

  # Get the study version history
	#
	# @return [Array] an array of Study::Version objects
	def history
  	return self.study_versions.to_a.sort_by{|x| x.version}
  end

  # Delete the object
  #
  # @raise Errors::DestroyError if deletion fails
  # @return [void] no return
  def delete
		study_versions.each {|x| x.delete}
    self.destroy
  rescue => e
    Errors.object_destroy_error(C_CLASS_NAME, __method__.to_s, e)
  end

=begin
  def clone
    Neo4j::ActiveBase.run_transaction do |tx|
      new_study = Study.create(self.attributes)
      self.study_versions.to_a.uniq.each do |sv|
        sv.clone
      end
      new_study.save!
      new_study.errors.any? ? tx.mark_failed : new_study.valid?
    end
  rescue Neo4j::ActiveNode::Persistence::RecordInvalidError => exception
    self.errors[:base] << "Failed to clone #{exception}"
    return false
  end
=end

end