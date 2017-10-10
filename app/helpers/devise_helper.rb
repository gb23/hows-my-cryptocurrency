module DeviseHelper
    def devise_error_messages!
      return "" unless devise_error_messages?
  
      messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg, class: "db fw6 lh-copy f6") }.join
      sentence = I18n.t("errors.messages.not_saved",
                        :count => resource.errors.count,
                        :resource => resource.class.model_name.human.downcase)
  
      html = <<-HTML
      <div id="error_explanation" class="min_w-100 bg-black-90 top-0 ph3 ph4-m ph5-l tc">
        <h5>#{sentence}</h5>
        
        <ul>#{messages}</ul>
      </div>
      HTML
  
      html.html_safe
    end
  
    def devise_error_messages?
      !resource.errors.empty?
    end
  
  end