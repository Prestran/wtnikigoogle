class Query < ApplicationRecord
  require 'mechanize'

  belongs_to :user
  has_many :query_results, dependent: :destroy

  validates_presence_of :name

  INVALID_TEXT = ['', 'Zaloguj się'].freeze

  def build_query(searched_query)
    results = search_query searched_query

    begin
      ActiveRecord::Base.transaction do
        update! name: searched_query
        results.each do |result|
          next if INVALID_TEXT.include?(result.text)
          query_results.create!(text: result.text, uri: result.resolved_uri)
        end
      end

    rescue ActiveRecord::RecordInvalid => exception
      Rails.logger.info exception.message
      return false
    end
    true
  end

  def self.refresh_queries
    all.each(&:check_refresh)
  end

  def search_query(searched_query)
    url = 'http://google.com'
    agent = Mechanize.new
    page = agent.get(url)

    form = page.form_with name: 'f'
    input = form.field_with name: 'q'
    input.value = searched_query
    new_page =  form.submit
    new_page.links_with href: /url\?q/
  end

  def check_refresh
    new_results = search_query name
    return false if new_results.count == 1

    begin
      ActiveRecord::Base.transaction do
        query_results.each_with_index do |query_result, index|
          next if new_results[index].nil?

          if query_result.text != new_results[index].text || query_result.uri != new_results[index].resolved_uri
            query_result.update(text: new_results[index].text, uri: new_results[index].resolved_uri)
          end
        end
      end
    rescue ActiveRecord::RecordInvalid => exception
      Rails.logger.info exception.message
      return false
    end
    true
  end

end
