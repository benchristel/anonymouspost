class Post
  include Mongoid::Document

  field :message, type: String

  def as_json(*)
    super.slice('message')
  end

  def self.create_from request_params
    create request_params.require(:post).permit(*mass_assignable_fields)
  end

  def self.mass_assignable_fields
    %w[message]
  end
end
