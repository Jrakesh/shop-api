require 'spec_helper'
require 'faker'

# Shop create unit testing.
describe 'The shop' do
  url = 'shops/create'

  describe 'create api' do
    describe 'the api key' do
      context 'when entered the valid api key' do
        let(:api_key) { '1e26686d806d82144a71ea9a99d1b3169adaad917' }

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

    describe 'the shop has empty information' do
      let(:api_key) { '1e26686d806d82144a71ea9a99d1b3169adaad917' }

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

    describe 'entered shop information' do
      let(:api_key) { '1e26686d806d82144a71ea9a99d1b3169adaad917' }

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
        describe 'the shop has existing information then' do
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

        describe 'the shop has existing address then' do
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

        describe 'the shop has existing latitude and longitude then' do
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

        describe 'the sop has out of range latitude' do
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

        describe 'the sop has out of range longitude' do
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
end