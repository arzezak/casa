class NotesController < ApplicationController
  before_action :find_volunteer
  before_action :find_note, only: %i[edit update destroy]

  def create
    authorize Note
    @volunteer.notes.create(note_params)
    redirect_to edit_volunteer_path(@volunteer)
  end

  def edit
    authorize @note
  end

  def update
    authorize @note
    @note.update(note_params)

    redirect_to edit_volunteer_path(@volunteer)
  end

  def destroy
    @note.destroy

    redirect_to edit_volunteer_path(@volunteer)
  end

  private

  def find_note
    @note = @volunteer.notes.find_by(id: params[:id])
    unless @note
      redirect_to root_path
      return
    end
  end

  def find_volunteer
    @volunteer = current_user.casa_org.volunteers.find_by(id: params[:volunteer_id])
    unless @volunteer
      redirect_to root_path
      return
    end
  end

  def note_params
    params.require(:note).permit(:content).merge({creator_id: current_user.id})
  end
end
