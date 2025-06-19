Turbo::Streams::TagBuilder.module_eval do
  def invoke(action, selector)
    @template.content_tag("turbo-stream",
      @template.tag.send(:"#{action}_modal", selector: selector),
      action: action, target: selector)
  end
end