class LedgersController < ApplicationController
  include LedgerFormatter
  before_action :set_ledger, only: %i[ show edit update destroy ]

  # GET /ledgers or /ledgers.json
  def index
    # Since we don't have the API response we are reading response from json files in the data folder.
    data = File.read(File.join(Rails.root,'data',"#{params[:ledger]}.json"))

    @ledgers = []
    @ledger_ids = []
    #Removes ledgers with duplicate activity_ids and to display in user-friendly information
    JSON.parse(data).each do |ledger|
      if not @ledger_ids.include? ledger['activity_id']
        data = formatted_ledger(ledger)
        @ledgers << data
        @ledger_ids << ledger['activity_id']
      end
    end
    #Sorts in descending order by date, and ascending order by balance
    @ledgers = @ledgers.sort do |s, t| 
      [t['date'], s['balance']] <=> [s['date'], t['balance']]
    end
  end

  # GET /ledgers/1 or /ledgers/1.json
  def show
  end

  # GET /ledgers/new
  def new
    @ledger = Ledger.new
  end

  # GET /ledgers/1/edit
  def edit
  end

  # POST /ledgers or /ledgers.json
  def create
    @ledger = Ledger.new(ledger_params)

    respond_to do |format|
      if @ledger.save
        format.html { redirect_to ledger_url(@ledger), notice: "Ledger was successfully created." }
        format.json { render :show, status: :created, location: @ledger }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ledger.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ledgers/1 or /ledgers/1.json
  def update
    respond_to do |format|
      if @ledger.update(ledger_params)
        format.html { redirect_to ledger_url(@ledger), notice: "Ledger was successfully updated." }
        format.json { render :show, status: :ok, location: @ledger }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ledger.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ledgers/1 or /ledgers/1.json
  def destroy
    @ledger.destroy

    respond_to do |format|
      format.html { redirect_to ledgers_url, notice: "Ledger was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ledger
      @ledger = Ledger.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ledger_params
      params.fetch(:ledger, :ledger_name, {})
    end
end