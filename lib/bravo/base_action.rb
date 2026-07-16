class Bravo::BaseAction
  class << self
    # Human label ("Import Items"), HTML message lambda, submit button label
    attr_accessor :title, :message, :confirm_button_label

    def key = name.demodulize.underscore
  end

  attr_reader :success_message, :error_message

  def fields
  end

  def field(id, **options, &block)
    @collected_fields << Bravo::Field.new(id, **options, &block)
  end

  def all_fields
    @all_fields ||= begin
      @collected_fields = []
      fields
      @collected_fields
    end
  end

  # Subclasses implement handle(fields:, current_user:, **) and call
  # succeed/error to report the outcome.
  def handle(**)
    raise NotImplementedError
  end

  def succeed(message)
    @success_message = message
  end

  def error(message)
    @error_message = message
  end

  # No-op: Bravo action dialogs close on submit; kept for Avo API parity.
  def close_modal
  end
end
