class EventsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_event, only: %i[show edit update destroy]

  # GET /events or /events.json
  def index
    @events = Event.all
    @recent_events = Event.added_in_last_30_days
    @upcoming_events = Event.in_next_week
  end

  # GET /events/1 or /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = current_user.events.new  # Crear un evento asociado al usuario actual
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @event = current_user.events.new(event_params)  # Asignar el user_id al evento creado

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: "El evento fue creado exitosamente." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: "El evento fue actualizado exitosamente." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_path, status: :see_other, notice: "El evento fue eliminado exitosamente." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:name, :date, :description)
  end
end
