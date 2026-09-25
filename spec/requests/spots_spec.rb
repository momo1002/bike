# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Spots', type: :request do
  let!(:user) do
    User.create!(
      username: 'もも',
      email: 'momo@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
  end

  before do
    post login_path, params: {
      email: user.email,
      password: 'password'
    }
  end

  describe 'POST /spots' do
    it 'スポットを投稿できる' do
      expect do
        post spots_path, params: {
          spot: {
            title: '角島大橋',
            description: '絶景スポット',
            address: '山口県下関市'
          }
        }
      end.to change(Spot, :count).by(1)

      expect(response).to redirect_to(spots_path)
    end

    it '画像付きでスポットを投稿できる' do
      image = fixture_file_upload(
        Rails.root.join('spec/fixtures/files/test.jpg'),
        'image/jpeg'
      )

      expect do
        post spots_path, params: {
          spot: {
            title: '角島大橋',
            description: '絶景スポット',
            address: '山口県下関市',
            images: [image]
          }
        }
      end.to change(Spot, :count).by(1)

      expect(Spot.last.images).to be_attached
    end
  end

  describe 'GET /spots' do
    let!(:spot) do
      Spot.create!(
        title: '秋吉台',
        description: '絶景ロード',
        address: '山口県',
        user: user
      )
    end

    it '一覧ページを表示できる' do
      get spots_path

      expect(response).to have_http_status(:ok)
    end

    it 'スポットタイトルが表示される' do
      get spots_path

      expect(response.body).to include('秋吉台')
    end
  end

  describe 'GET /spots/:id' do
    let!(:spot) do
      Spot.create!(
        title: '角島大橋',
        description: '絶景スポット',
        address: '山口県下関市',
        user: user
      )
    end

    it '詳細ページを表示できる' do
      get spot_path(spot)

      expect(response).to have_http_status(:ok)
    end

    it 'スポット情報が表示される' do
      get spot_path(spot)

      expect(response.body).to include('角島大橋')
      expect(response.body).to include('絶景スポット')
      expect(response.body).to include('山口県下関市')
    end

    it '投稿者名が表示される' do
      get spot_path(spot)

      expect(response.body).to include('もも')
    end
  end

  describe 'PATCH /spots/:id' do
    let!(:spot) do
      Spot.create!(
        title: '角島大橋',
        description: '絶景スポット',
        address: '山口県下関市',
        user: user
      )
    end

    it 'スポット情報を更新できる' do
      patch spot_path(spot), params: {
        spot: {
          title: '秋吉台',
          description: 'カルストロード',
          address: '山口県美祢市'
        }
      }

      spot.reload

      expect(spot.title).to eq('秋吉台')
      expect(spot.description).to eq('カルストロード')
      expect(spot.address).to eq('山口県美祢市')

      expect(response).to redirect_to(spot_path(spot))
    end
  end

  describe 'DELETE /spots/:id' do
    let!(:spot) do
      Spot.create!(
        title: '角島大橋',
        description: '絶景スポット',
        address: '山口県下関市',
        user: user
      )
    end

    it 'スポットを削除できる' do
      expect do
        delete spot_path(spot)
      end.to change(Spot, :count).by(-1)

      expect(response).to redirect_to(spots_path)
    end
  end
end
