require 'rails_helper'

RSpec.describe Query do
  describe '#build_query' do
    let(:query) { create(:query) }

    context '' do
      it 'creates query and query results' do
        expect(query.build_query('warhammer') ).to eq true
        expect(query.query_results.count).to be > 0
      end

      it 'updates query initial name' do
        expect { query.build_query('warhammer') }.to change(query, :name).from('abc').to('warhammer')
      end
    end

    context 'there occured some error in updating query name or creating query results' do
      it 'returns false' do
        expect(query.build_query('') ).to eq false
      end
    end
  end

  describe '#search_query' do
    let(:query) { create(:query) }

    context 'finds results searched for' do
      it 'return results' do
        result = query.search_query('warhammer')
        expect(result).to be_a Array
        expect(result.size).to be >= 8
        expect(result[5]).to be_a Mechanize::Page::Link
        expect(result[5].text).not_to be_empty
        expect(result[5].resolved_uri).to be_a URI::HTTP
      end
    end

    context 'there are no results' do
      it 'returns one link to log in' do
        result = query.search_query('adsgdishfbasf4$#$^#QREgdhwy4qqraew gfay53qyreg')
        expect(result.count).to eq 1
        expect(result.first.text).to eq 'Zaloguj się'
      end
    end
  end

  describe '#check_refresh' do
    let(:query) { create(:query) }

    before(:each) do
      query.build_query('warhammer')
    end

    context 'there are no new results' do
      it 'returns true' do
        expect(query.check_refresh).to eq true
      end
    end

    context 'one of query results have changed' do
      before do
        query.query_results[4].update(text: 'abc', uri: 'https://www.google.com')
      end

      it 'updates changed result' do
        qr = query.query_results[4]
        expect { query.check_refresh }.to change(qr, :text)
        expect { query.check_refresh }.to change(qr, :uri)
      end
    end

    context 'there are no results' do
      before { query.update name: 'adsgdishfbasf4$#$^#QREgdhwy4qqraew gfay53qyreg' }
      it 'returns false' do
        expect(query.check_refresh).to eq false
      end
    end
  end
end

