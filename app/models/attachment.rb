class Attachment < ApplicationRecord

  BUCKET = Rails.application.secrets.s3.try(:[], :bucket)
  S3_REGION = Rails.application.secrets.s3.try(:[], :s3_region)
  ACCESS_KEY_ID = Rails.application.secrets.s3.try(:[], :access_key_id)
  SECRET_ACCESS_KEY = Rails.application.secrets.s3.try(:[], :secret_access_key)
  CLOUDFRONT_URL = Rails.application.secrets.s3.try(:[], :cloudfront_url)

  has_attached_file :file,
                    :storage => :s3,
                    :url => ':s3_alias_url',
                    :s3_host_alias => CLOUDFRONT_URL,
                    :s3_region => 'ap-south-1',
                    :s3_protocol => :https,
                    :s3_credentials => Proc.new{|a| a.instance.s3_credentials }
  #:s3_permissions => { :original => :private }
  scope :image_type, -> (image_type) { where(image_type: image_type) }
  ALLOWED_FILE_TYPES = ['image/jpeg', 'image/jpg', 'image/png', 'application/pdf', 'image/bmp', 'image/gif','text/plain']

  do_not_validate_attachment_file_type :file
  validates_attachment_content_type :file, content_type: ALLOWED_FILE_TYPES

  # Associations
  belongs_to :attachable, polymorphic: true, required: false


  protected
    
  def decode_base64(data,content_type,original_filename)
    if data && content_type && original_filename
      decoded_data = Base64.decode64(data)
      data = StringIO.new(decoded_data)
      data.class_eval do
        attr_accessor :content_type, :original_filename
      end
      data.content_type = content_type
      data.original_filename = File.basename(original_filename)
      data
    end
  end
end