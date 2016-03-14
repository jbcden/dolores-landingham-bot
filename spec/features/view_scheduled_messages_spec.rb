require "rails_helper"

feature "View scheduled messages" do
  scenario "sees all message details" do
    login_with_oauth
    visit root_path
    create_scheduled_messages

    visit scheduled_messages_path

    expect(page).to have_content(first_scheduled_message.title)
    expect(page).to have_content(first_scheduled_message.body)
    expect(page).to have_content(first_scheduled_message.days_after_start)
    expect(page).to have_content(formatted_time(first_scheduled_message))
    expect(page).to have_content(second_scheduled_message.title)
    expect(page).to have_content(second_scheduled_message.body)
    expect(page).to have_content(second_scheduled_message.days_after_start)
    expect(page).to have_content(formatted_time(second_scheduled_message))
  end

  scenario "sees pagination controls" do
    allow(Kaminari.config).to receive(:default_per_page).and_return(1)

    login_with_oauth
    visit root_path
    create_scheduled_messages

    visit scheduled_messages_path

    expect(page).to have_content(first_scheduled_message.title)
    expect(page).to have_content(first_scheduled_message.body)
    expect(page).to have_content(first_scheduled_message.days_after_start)
    expect(page).to have_content(formatted_time(first_scheduled_message))

    expect(page).not_to have_content(second_scheduled_message.title)

    expect(page).to have_content("Next")
    expect(page).to have_content("Last")

    click_on "Last"

    expect(page).not_to have_content(first_scheduled_message.title)

    expect(page).to have_content(second_scheduled_message.title)
    expect(page).to have_content(second_scheduled_message.body)
    expect(page).to have_content(second_scheduled_message.days_after_start)
    expect(page).to have_content(formatted_time(second_scheduled_message))

    expect(page).to have_content("Prev")
    expect(page).to have_content("First")
  end

  scenario "see message in the correct order" do
    login_with_oauth
    visit root_path
    create_scheduled_messages

    visit scheduled_messages_path

    expect(page).to have_message_in_order(message: first_scheduled_message,
                                          order: 1)
    expect(page).to have_message_in_order(message: second_scheduled_message,
                                          order: 2)
  end

  private

  def have_message_in_order(message:, order:)
    order = order + 1
    have_selector("table > tr:nth-child(#{order}) > td:nth-child(2)",
                  text: formatted_time(message).strip)
  end

  def formatted_time(scheduled_message)
    scheduled_message.time_of_day.strftime("%l:%M %p")
  end

  def create_scheduled_messages
    second_scheduled_message
    first_scheduled_message
  end

  def first_scheduled_message
    @first_scheduled_message ||= create(:scheduled_message,
                                        time_of_day: '2000-01-01 14:00:00 UTC')
  end

  def second_scheduled_message
    @second_scheduled_message ||= create(:scheduled_message,
                                         title: 'Onboarding message 2',
                                         time_of_day: '2000-01-01 16:00:00 UTC')
  end
end
