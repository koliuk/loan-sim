module FormHelper
    
    def form_field_for(form, field, opts={}, &block)
        add_label = !opts.fetch(:label, nil).nil?
        add_help = !opts.fetch(:help, nil).nil?

        has_errors = form.object.errors[field].present?
        _class = "form-control #{'is-invalid' if has_errors}"

        content_tag :div, class: opts.fetch(:class, nil) do
            concat form.label(field, opts.fetch(:label)) if add_label
            concat capture(_class, &block)
            concat help_for(field, opts.fetch(:help)) if add_help
            concat errors_for(form, field)
        end
    end

    def errors_for(form, field)
        content_tag(:p, form.object.errors[field].try(:first), class: 'form-text text-danger', id: "#{field}_error")
    end

    def help_for(field, help)
        content_tag(:small, help, class: 'form-text text-muted', id: "#{field}_help")
    end

    def form_elem(form, field, opts={}, &block)
        _aclass = 'a'
        content_tag :div, class: "form-group" do
            concat form.label(field, class: 'control-label') 
            concat capture(_aclass, &block)
        end
    end

    def format_curr_amount(money)
        money.format(symbol: money.currency.iso_code, thousands_separator: " ") 
    end

end
