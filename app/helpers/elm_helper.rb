# frozen_string_literal: true

module ElmHelper
  def elm_component(name, props = {}, options = {}, &block)
    options = { tag: options } if options.is_a?(Symbol)

    html_options = options.reverse_merge(data: {})
    html_tag = html_options[:tag] || :div

    # remove internally used properties so they aren't rendered to DOM
    html_options.except!(:tag)
    id = [name, rand(10_000_000)].join('-')
    html_options[:id] = id

    html = content_tag(html_tag, '', html_options, false, &block)
    html << elm_js_tag(name, props)
  end

  def elm_js_tag(name, props)
    if (flags = props[:flags])
      javascript_tag("window.Elm.#{name}.init({ node: document.getElementById('#{id}'), flags: #{flags.to_json} })")
    else
      javascript_tag("window.Elm.#{name}.init({ node: document.getElementById('#{id}') })")
    end
  end
end
