require 'rails_helper'

describe 'Dog resource', type: :feature do

  describe 'when user is signed in' do
    let(:user) { create(:user) }

    before(:each) do
      login_as(user, :scope => :user)
    end

    it 'can create a profile' do
      visit new_dog_path
      fill_in 'Name', with: 'Speck'
      fill_in 'Description', with: 'Just a dog'
      attach_file 'dog_images', 'spec/fixtures/images/speck.jpg'
      click_button 'Create Dog'
      expect(Dog.count).to eq(1)
    end

    it 'can edit a dog profile when user is owner' do
      dog = create(:dog, user_id: user.id)
      visit edit_dog_path(dog)
      fill_in 'Name', with: 'Speck'
      click_button 'Update Dog'
      expect(dog.reload.name).to eq('Speck')
    end

    it 'can delete a dog profile when user is owner' do
      dog = create(:dog, user_id: user.id)
      visit dog_path(dog)
      click_link "Delete #{dog.name}'s Profile"
      expect(Dog.count).to eq(0)
    end
  end
end
