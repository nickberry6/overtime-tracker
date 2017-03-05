require 'rails_helper'

describe 'navigate' do
  before do
    @user = FactoryGirl.create(:user)
    login_as(@user, :scope => :user)
  end

  describe 'index' do
    before do
      visit posts_path
    end

    it 'can be reached successfully' do
      expect(page.status_code).to eq(200)
    end

    it 'has a title of Posts' do
      expect(page).to have_content(/Posts/)
    end

    it 'has a list of posts' do
      post1 = FactoryGirl.create(:post, user_id: @user.id)
      post2 = FactoryGirl.create(:second_post, user_id: @user.id)
      visit posts_path
      expect(page).to have_content(/rationale|content/)
    end

    it 'has a scope so that only post creators can see their posts' do
      post1 = FactoryGirl.create(:post, user_id: @user.id)
      post2 = FactoryGirl.create(:second_post, user_id: @user.id)

      other_user = FactoryGirl.create(:non_authorized_user)
      post_from_other_user = Post.create(date: Date.today, rationale: "This post shouldnt be seen.", user_id: other_user.id)

      visit posts_path

      expect(page).to_not have_content(/This post shouldnt be seen./)
    end
  end

  describe 'new' do
    it 'has a link from the homepage' do
      visit root_path
      click_link("new_post_from_nav")
      expect(page.status_code).to eq(200)
    end
  end

  describe 'delete' do
    it 'can be deleted' do
      @post = FactoryGirl.create(:post, user_id: @user.id)
      visit posts_path
      click_link("delete_post_#{@post.id}_from_index")
      expect(page.status_code).to eq(200)
    end
  end

  describe 'creation' do
    before do
      visit new_post_path
    end

    it 'has a new form that can be reached' do
      expect(page.status_code).to eq(200)
    end

    it 'can be created from new form page' do
      fill_in 'post[date]', with: Date.today
      fill_in 'post[rationale]', with: "Some Rationale"
      click_on "Save"

      expect(page).to have_content("Some Rationale")
    end

    it 'will have a user associated with it' do
      fill_in 'post[date]', with: Date.today
      fill_in 'post[rationale]', with: "User_Association"
      click_on "Save"

      expect(User.last.posts.last.rationale).to eq("User_Association")
    end
  end

  describe 'edit' do
    before do
      @post = FactoryGirl.create(:post, user_id: @user.id)
    end

    it 'can be edited by authorized user' do
      visit edit_post_path(@post)

      fill_in 'post[date]', with: Date.today
      fill_in 'post[rationale]', with: "edited content"
      click_on "Save"
      expect(page.status_code).to eq(200)
    end

    it 'cannot be edited by a non authorized user' do
      logout(:user)
      @non_authorized_user = FactoryGirl.create(:non_authorized_user)
      login_as(@non_authorized_user, :scope => :user)


      visit edit_post_path(@post)

      expect(current_path).to eq(root_path)
    end
  end
end
