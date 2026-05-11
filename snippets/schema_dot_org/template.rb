gem "perron" unless File.read("Gemfile").include?("perron")

gem "schema_dot_org", "~> 2.5" unless File.read("Gemfile").include?("schema_dot_org")

after_bundle do
  unless File.exist?("config/initializers/perron.rb")
    rails_command "perron:install"
  end

  create_file "app/controllers/concerns/structured_data.rb", <<~'TEXT', force: true
module StructuredData
  extend ActiveSupport::Concern

  included do
    helper_method :structured_data_tags
  end

  def structured_data_tags
    view_context.safe_join(schemas.map(&:to_s), "\n") if schemas.any?
  end

  private

  def structured_data = yield schemas
  def schemas = @schemas ||= Schemas.new

  class Schemas
    include Enumerable

    def initialize = @schemas = []
    def add(data) = @schemas << data
    def each(&) = @schemas.each(&)
  end
end

TEXT

create_file "app/models/schema_dot_org//article.rb", <<~'TEXT', force: true
module SchemaDotOrg
  class Article < SchemaType
    validated_attr :headline, type: String, presence: true
    validated_attr :description, type: String, allow_nil: true
    validated_attr :image, type: String, allow_nil: true
    validated_attr :url, type: String, allow_nil: true
    validated_attr :publisher, type: SchemaDotOrg::Organization, allow_nil: true
    validated_attr :author, type: SchemaDotOrg::Person, allow_nil: true
    validated_attr :date_published, type: String, allow_nil: true
  end
end

TEXT
end
