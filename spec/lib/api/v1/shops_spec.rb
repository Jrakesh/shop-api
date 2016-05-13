require 'spec_helper'
require 'faker'

# Shop create unit testing.
describe 'the "Shop"' do
  let(:api_key) { '1e26686d806d82144a71ea9a99d1b3169adaad917' }

  RSpec.shared_examples "post api key" do
    describe 'the "Api" key' do
      context 'when entered the valid api key' do

        it 'successfully accessed api' do
          data = {
              name: "Sharma Shopping Centre",
              address: "Bhargav Rd, Jay Ambe Society, Saijpur Bogha, Ahmedabad, Gujarat 382340",
              latitude: "23.0657155",
              longitude: "72.6298079"
          }
          response = PostAPIResponse(url, data, api_key)
          expect(response['error']['code'].to_i).not_to eq -101
        end
      end
      context 'when entered the invalid api key' do
        let(:api_key) { '1e26686d806d82144a71ea9a99d1b3169adaad123' }

        it 'unsuccessful accessed api' do
          data = {
              name: "Sharma Shopping Centre",
              address: "Bhargav Rd, Jay Ambe Society, Saijpur Bogha, Ahmedabad, Gujarat 382340",
              latitude: "23.0657155",
              longitude: "72.6298079"
          }
          response = PostAPIResponse(url, data, api_key)
          expect(response['error']['code'].to_i).to eq -101
        end
      end
    end
  end

  RSpec.shared_examples "get api key" do
    describe 'the "Api key"' do
      context 'when entered the valid api key' do

        it 'successfully accessed api' do
          response = GetAPIResponse(url, api_key)
          expect(response['status']).to eq 0
        end
      end
      context 'when entered the invalid api key' do
        let(:api_key) { '1e26686d806d82144a71ea9a99d1b3169adaad123' }

        it 'unsuccessful accessed api' do
          response = GetAPIResponse(url, api_key)
          expect(response['error']['code'].to_i).to eq -101
        end
      end
    end
  end

  describe 'create "Api"' do
    let(:url) { 'shops/create' }

    include_examples "post api key"

    describe 'the "Shop" has empty information' do
      context 'when entered all empty information' do
        it 'the shop has blank information' do
          data = {
              name: '',
              address: '',
              latitude: '',
              longitude: ''
          }
          response = PostAPIResponse(url, data, api_key)
          expect(response['error']['code'].to_i).to eq -103
        end
      end

      context 'and name is empty' do
        it 'the shop has blank information' do
          data = {
              name: '',
              address: Faker::Address.street_address + ', ' +  Faker::Address.street_name + ', ' +  Faker::Address.city + ', ' +  Faker::Address.state + ', ' + Faker::Address.country + ', ' + Faker::Address.zip_code,
              latitude: Faker::Address.latitude,
              longitude: Faker::Address.longitude
          }
          response = PostAPIResponse(url, data, api_key)
          expect(response['error']['code'].to_i).to eq -103
        end
      end

      context 'and address is empty' do
        it 'the shop has blank information' do
          data = {
              name: Faker::Name.name,
              address: '',
              latitude: Faker::Address.latitude,
              longitude: Faker::Address.longitude
          }
          response = PostAPIResponse(url, data, api_key)
          expect(response['error']['code'].to_i).to eq -103
        end
      end

      context 'and latitude is empty' do
        it 'the shop has blank information' do
          data = {
              name: Faker::Name.name,
              address: Faker::Address.street_address + ', ' +  Faker::Address.street_name + ', ' +  Faker::Address.city + ', ' +  Faker::Address.state + ', ' + Faker::Address.country + ', ' + Faker::Address.zip_code,
              latitude: '',
              longitude: Faker::Address.longitude
          }
          response = PostAPIResponse(url, data, api_key)
          expect(response['error']['code'].to_i).to eq -103
        end
      end

      context 'and longitude is empty' do
        it 'the shop has blank information' do
          data = {
              name: Faker::Name.name,
              address: Faker::Address.street_address + ', ' +  Faker::Address.street_name + ', ' +  Faker::Address.city + ', ' +  Faker::Address.state + ', ' + Faker::Address.country + ', ' + Faker::Address.zip_code,
              latitude: Faker::Address.latitude,
              longitude: ''
          }
          response = PostAPIResponse(url, data, api_key)
          expect(response['error']['code'].to_i).to eq -103
        end
      end
    end

    describe 'entered "Shop" information' do
      context 'when the shop has valid information' do
        it 'shop created successfully' do
          data = {
              name: Faker::Name.name,
              address: Faker::Address.street_address + ', ' +  Faker::Address.street_name + ', ' +  Faker::Address.city + ', ' +  Faker::Address.state + ', ' + Faker::Address.country + ', ' + Faker::Address.zip_code,
              latitude: Faker::Address.latitude,
              longitude: Faker::Address.longitude
          }
          response = PostAPIResponse(url, data, api_key)
          expect(response['status']).to eq 0
        end
      end

      context 'and the shop has not valid information' do
        describe 'the "Shop" has existing information then' do
          it 'the shop is not created successfully' do
            data = {
                name: "Sharma Shopping Centre",
                address: "Bhargav Rd, Jay Ambe Society, Saijpur Bogha, Ahmedabad, Gujarat 382340",
                latitude: "23.0657155",
                longitude: "72.6298079"
            }
            response = PostAPIResponse(url, data, api_key)
            expect(response['error']['code'].to_i).to eq -105
          end
        end

        describe 'the "Shop" has existing address then' do
          it 'the shop is not created successfully' do
            data = {
                name: "Mohan Lal",
                address: "Bhargav Rd, Jay Ambe Society, Saijpur Bogha, Ahmedabad, Gujarat 382340",
                latitude: "23.0657155",
                longitude: "72.6298079"
            }
            response = PostAPIResponse(url, data, api_key)
            expect(response['error']['code'].to_i).to eq -105
          end
        end

        describe 'the "Shop" has existing latitude and longitude then' do
          it 'the shop is not created successfully' do
            data = {
                name: "Mohan Lal",
                address: "Shahani Para",
                latitude: "23.0657155",
                longitude: "72.6298079"
            }
            response = PostAPIResponse(url, data, api_key)
            expect(response['error']['code'].to_i).to eq -105
          end
        end

        describe 'the "Shop" has out of range latitude' do
          context 'when the shop has latitude less than -90' do
            it 'the shop is not created successfully' do
              data = {
                  name: "Mohan Lal",
                  address: "Shahani Para",
                  latitude: "-100",
                  longitude: "72.6298079"
              }
              response = PostAPIResponse(url, data, api_key)
              expect(response['error']['code'].to_i).to eq -106
            end
          end

          context 'when the shop has latitude greater than 90' do
            it 'the shop is not created successfully' do
              data = {
                  name: "Mohan Lal",
                  address: "Shahani Para",
                  latitude: "100",
                  longitude: "72.6298079"
              }
              response = PostAPIResponse(url, data, api_key)
              expect(response['error']['code'].to_i).to eq -106
            end
          end
        end

        describe 'the "Shop" has out of range longitude' do
          context 'when the shop has longitude less than -180' do
            it 'the shop is not created successfully' do
              data = {
                  name: "Mohan Lal",
                  address: "Shahani Para",
                  latitude: "23.0657155",
                  longitude: "-200"
              }
              response = PostAPIResponse(url, data, api_key)
              expect(response['error']['code'].to_i).to eq -107
            end
          end

          context 'when the shop has longitude greater than 180' do
            it 'the shop is not created successfully' do
              data = {
                  name: "Mohan Lal",
                  address: "Shahani Para",
                  latitude: "23.0657155",
                  longitude: "200"
              }
              response = PostAPIResponse(url, data, api_key)
              expect(response['error']['code'].to_i).to eq -107
            end
          end
        end
      end
    end
  end

  describe 'get all "Shop Detail" api' do
    let(:url) { 'shops/get_all_details' }

    include_examples "get api key"

    describe 'get "Shop" information' do
      it 'successfully get shop information' do
        response = GetAPIResponse(url, api_key)
        expect(response['status']).to eq 0
      end
    end
  end
end