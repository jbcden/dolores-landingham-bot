require "rails_helper"

feature "Delete scheduled messages" do
  scenario "from list of scheduled messages", :js do
    message = create(:scheduled_message)

    login_with_oauth
    visit scheduled_messages_path
    click_accept_on_javascript_popup do
      page.find(".button-delete").click
    end

    expect(page).to have_content("You deleted #{message.title}")
  end
end

