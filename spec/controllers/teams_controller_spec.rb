require 'rails_helper'
require 'trinity'

RSpec.describe TeamsController, type: :controller do
  let!(:user) { FactoryGirl.create(:user, email: "#{SecureRandom.hex}@foo.con") }
  let(:user2) { FactoryGirl.create(:user, email: 'foo@bar.con') }

  let(:valid_attributes) { {name: 'team 1', user: user} }
  let(:invalid_attributes) { {name: ''} }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TeamsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  def save_team(user)
    user.teams.map(&:save!)
  end

  before do
    Trinity::Current.reset!
  end

  describe "GET #index with default domain" do
    it "only lists current user 's team" do
      team = Team.create! valid_attributes.merge(user: user2)
      sign_in user
      user.reload
      user.teams << Team.create!(valid_attributes)
      get :index, params: {} #, session: valid_session
      expect(assigns(:team)).to eq(user.teams.asc(:id).first)
      expect(assigns(:teams)).to eq(user.teams)
      expect(assigns(:team_membership)).to have_attributes(team: user.default_team)
      expect(assigns(:team_membership)).to be_a_new(TeamMembership)
    end

    it 'set current team from domain' do
      team = FactoryGirl.create(:team, user: user)
      user.reload
      @request.host = "team-#{team.id.to_s}.noty.dev"
      sign_in user
      get :index, params: {} #, session: valid_session
      expect(assigns(:team)).to eq(team)
      expect(assigns(:teams)).to eq(user.teams)
      expect(assigns(:team_membership)).to have_attributes(team: team)
      expect(assigns(:team_membership)).to be_a_new(TeamMembership)
    end
  end

  describe "GET #show" do
    it "assigns the requested team as @team" do
      sign_in user
      team = user.default_team
      get :show, params: {id: team.to_param} # session: valid_session
      expect(assigns(:team_membership)).to have_attributes(team: team)
      expect(assigns(:team_membership)).to be_a_new(TeamMembership)
      expect(subject).to render_template("teams/index")
    end

    it "forbidden if user cannot manage his team" do
      team = FactoryGirl.create(:team, user: user2)
      user.reload
      @request.host = "team-#{team.id.to_s}.noty.dev"
      sign_in user
      get :index, params: {} #, session: valid_session
      assert_response :forbidden
    end
  end

  #describe "GET #new" do
  #  it "assigns a new team as @team" do
  #    sign_in user
  #    get :new, params: {}, format: :html#, session: valid_session
  #    expect(assigns(:team)).to be_a_new(Team)
  #  end
  #end

  #describe "GET #edit" do
  #  it "assigns the requested team as @team" do
  #    team = Team.create! valid_attributes
  #    get :edit, params: {id: team.to_param}, session: valid_session
  #    expect(assigns(:team)).to eq(team)
  #  end
  #end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Team" do
        sign_in user
        expect {
          post :create, params: {team: valid_attributes}, session: valid_session
        }.to change(Team, :count).by(1)
      end

      it "assigns a newly created team as @team" do
        sign_in user
        post :create, params: {team: valid_attributes}, session: valid_session
        expect(assigns(:team)).to be_a(Team)
        expect(assigns(:team)).to be_persisted
        expect(assigns(:team)).to have_attributes(user: user)
      end

      it "redirects to the created team" do
        sign_in user
        post :create, params: {team: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Team.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved team as @team" do
        sign_in user
        post :create, params: {team: invalid_attributes}, session: valid_session
        expect(assigns(:team)).to be_a_new(Team)
        expect(response).to redirect_to(teams_path)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {name: 'changed name'}
      }

      it "updates the requested team" do
        team = Team.create! valid_attributes
        sign_in user
        put :update, params: {id: team.to_param, team: new_attributes}, session: valid_session
        team.reload
        expect(team.name).to eq(new_attributes[:name])
        expect(response).to redirect_to(team)
      end

      it 'forbid update team user cannot mangage' do
        team = Team.create! valid_attributes.merge(user: user2)
        sign_in user
        put :update, params: {id: team.to_param, team: new_attributes}, session: valid_session
        team.reload
        assert_response :forbidden
        expect(team.name).to eq(valid_attributes[:name])
      end

      it "assigns the requested team as @team" do
        team = Team.create! valid_attributes
        sign_in user
        put :update, params: {id: team.to_param, team: valid_attributes}, session: valid_session
        expect(assigns(:team)).to eq(team)
      end
    end

  #  context "with invalid params" do
  #    it "assigns the team as @team" do
  #      team = Team.create! valid_attributes
  #      put :update, params: {id: team.to_param, team: invalid_attributes}, session: valid_session
  #      expect(assigns(:team)).to eq(team)
  #    end

  #    it "re-renders the 'edit' template" do
  #      team = Team.create! valid_attributes
  #      put :update, params: {id: team.to_param, team: invalid_attributes}, session: valid_session
  #      expect(response).to render_template("edit")
  #    end
  #  end
  end

  describe "DELETE #destroy" do
    it "destroys the requested team" do
      sign_in user
      team = Team.create! valid_attributes
      expect {
        delete :destroy, params: {id: team.to_param}, session: valid_session
      }.to change(Team, :count).by(-1)
    end

    it "redirects to the teams list" do
      sign_in user
      team = Team.create! valid_attributes
      delete :destroy, params: {id: team.to_param}, session: valid_session
      expect(response).to redirect_to(teams_url)
    end

    it "will not delete default team" do
      sign_in user
      team = user.default_team

      delete :destroy, params: {id: team.to_param}, session: valid_session
      assert_response :forbidden
      team.reload
    end
  end

end
