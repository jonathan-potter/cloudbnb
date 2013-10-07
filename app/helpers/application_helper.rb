module ApplicationHelper

  def checkbox_group(options)
    # options hash must include :collection, :ul_class, and :html_name
    @ul = options
    render "shared/checkbox_group"
  end

end
