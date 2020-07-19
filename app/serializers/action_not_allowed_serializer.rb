class ActionNotAllowedSerializer
  def initialize error
    @error = error
  end

  def serialize
    {
      success: false,
      errors: [I18n.t(:not_allowed, scope: [:errors, :action])]
    }
  end

  private
  attr_reader :error
end
