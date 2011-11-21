module Rack::Mailer::DslAccessor

  # Works a bit like attr_accessor only a bit more flexible.
  #
  #   class Builder
  #     extend DslAccessor
  #
  #     dsl_accessor :some_key
  #   end
  #
  #   b = Builder.new
  #   b.some_key = 'value'
  #   b.some_key 'new_val'
  #   puts b.some_key
  def dsl_accessor(*attributes)
    attr_writer *attributes
    attributes.each do |attribute|
      define_method attribute.to_sym do |*args|
        instance_variable_set "@#{attribute}", args.first if args.first
        instance_variable_get "@#{attribute}"
      end
    end
  end

end