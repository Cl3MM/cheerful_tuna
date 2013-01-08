# select2_ajax helper to make capybara work with ajax-enabled Select2 elements
# assumes 'placeholder' option is used in Select2 (if it is using ajax, it should be)
#
# usage: 
#
#    it "should have a select2 field for searching by team name" do
#        @team = Factory :team
#        select2_ajax @team.name, :from => "Select a Team", :minlength => 4
#        click_button "Join"
#        page.should have_content "You are now on '#{@team.name}'."
#    end

module CapybaraSelect2Helper
  def select2_select(text, options)
    raise "Must pass a hash containing 'from'" if not options.is_a?(Hash) or not options.has_key?(:from)
    page.find("#s2id_#{options[:from]} input.select2-input").click
    page.all("ul.select2-results li").each do |e|
      if e.text == text
        e.click
        return
      end
    end
  end

  def select2_ajax value, options={}
    raise "Must pass a hash containing 'from'" if not options.is_a?(Hash) or not options.has_key?(:from)

    placeholder = options[:from]
    minlength = options[:minlength] || 4

    click_link placeholder

    js = %Q|container = $('.select2-container:contains("#{placeholder}")');
            $('input[type=text]', container).val('#{value[0,minlength]}').trigger('keyup');
            window.setTimeout( function() {
              $('li:contains("#{value}")', container).click();
            }, 1000);|
    page.execute_script(js)
  end
end
