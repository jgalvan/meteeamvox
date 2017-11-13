class MeetingsController < ApplicationController
  before_action :authenticate_user!, except: [:upload_audio]
  before_action :set_meeting, only: [:show, :edit, :update, :destroy, :add_team]

  def index
    if params[:query]
      @meetings = current_user.search_meeting(params[:query])
    else
      @meetings = current_user.meetings
    end
  end

  def show
  end

  def new
    @meeting = Meeting.new(user: current_user, meetingTime: DateTime.now)
    if params[:team_id] 
      @meeting.team_id = params[:team_id] 
    end
  end

  def edit
  end

  def create
    @meeting = current_user.owned_meetings.new(meeting_params)
    if params[:team_id] 
      @meeting.team_id = params[:team_id] 
    end

    if @meeting.save
      redirect_to @meeting, notice: 'Meeting was successfully created.'
    else
      render :new
    end
  end

  def update
    if @meeting.update(meeting_params)
      redirect_to @meeting, notice: 'Meeting was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @meeting.user == current_user
      @meeting.destroy

      redirect_to meetings_url, notice: 'Meeting was successfully destroyed.'
    else
      redirect_to meetings_url, notice: 'Only the meeting\'s owner can delete this meeting.'
    end

  end

  def upload_audio
    require "google/cloud/speech"
    
    speech = Google::Cloud::Speech.new project: "meeteamvox", keyfile: "/Users/chuygalvan/Dropbox/ITESM/7mo\ semestre/Web/Project/MeeteamVox-e1a151622376.json"
    
    audio = speech.audio params[:audio],
                         encoding: :linear16,
                         language: "en-US"
    
    results = audio.recognize
    result = results.first
    transcript = result.try(:transcript) || "No audio detected."
    # result.confidence

    meeting = Meeting.find_by_id(params[:id])
    if meeting && !params[:test]
      meeting.transcript = transcript
      meeting.save!
    end

    respond_to do |format|
      msg = { :status => "ok", :message => "Success!", :transcript => transcript }
      format.json  { render :json => msg } # don't do msg.to_json
    end
  end

  def add_team
    if team = current_user.teams.find_by_id(params[:team])
      @meeting.team = team
      @meeting.save
    end
    redirect_to @meeting
  end

  private
    def set_meeting
      @meeting = current_user.meeting_with_id(params[:id])

      if @meeting.nil?
        redirect_to authenticated_root_path, error: "You do not have access to this meeting"
      end
    end

    def meeting_params
      params.require(:meeting).permit(:title, :subject, :user_id, :meetingTime, :team_id, :description, :query, :audio, :team_id)
    end
end
