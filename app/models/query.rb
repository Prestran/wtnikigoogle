class Query < ApplicationRecord
  require 'mechanize'

  belongs_to :user
  has_many :query_results, dependent: :destroy

  INVALID_TEXT = ['', 'Zaloguj się'].freeze

  def build_query(searched_query)
    results = search_query searched_query

    begin
      ActiveRecord::Base.transaction do
        update name: searched_query
        raise ActiveRecord::Rollback unless errors.empty?

        results.each do |result|
          next if INVALID_TEXT.include?(result.text)
          raise ActiveRecord::Rollback unless query_results.create(text: result.text, uri: result.resolved_uri)
        end
      end

    rescue ActiveRecord::RecordInvalid
      return false
    end
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
    return false if new_page.nil?

    results = new_page.links_with href: /url\?q/
    return false if results.empty?

    results
  end

  def check_refresh
    new_results = search_query name
    return false if new_results == false

    begin
      ActiveRecord::Base.transaction do
        query_results.each_with_index do |query_result, index|
          if query_result.text != new_results[index].text || query_result.uri != new_results[index].resolved_uri
            query_result.update(text: new_results[index].text, uri: new_results[index].resolved_uri)
          end
        end
      end
    rescue ActiveRecord::RecordInvalid
      return false
    end
  end

end
