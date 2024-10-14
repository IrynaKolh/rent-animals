class PetsController < ApplicationController
  before_action :authenticate_user!, except: ["index", "show"]
  before_action :set_pet, only: %i[ show edit update destroy ]
  before_action :authorize_user, only: [:edit, :update, :destroy]
  before_action :check_seller, only: [:new, :create, :edit, :update]

  # GET /pets or /pets.json
  def index
    @pets = Pet.all

    if params[:query].present?
      @pets = Pet.joins(:rich_text_description).where(
        "pets.name LIKE ? OR pets.category LIKE ? OR action_text_rich_texts.body LIKE ?",
        "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%"
      )     
    end

    if params[:category].present?
      @pets = @pets.where(category: params[:category])
    end

    if params[:sort].present?
      @pets = case params[:sort]
              when 'price_asc'
                @pets.order(price: :asc)
              when 'price_desc'
                @pets.order(price: :desc)
              else
                @pets
              end
    end

    if params[:min_price].present?
      @pets = @pets.where('price >= ?', params[:min_price])
    end

    if params[:max_price].present?
      @pets = @pets.where('price <= ?', params[:max_price])
    end

    @pets = @pets.page(params[:page]).per(12)
  end

  def search
    if params[:query].present?      
      redirect_to pets_path(params.permit(:query, :category, :sort, :min_price, :max_price))  
    else
      @pets = @pets.page(params[:page]).per(12)
      render :index
    end
  end
  
  def my_pets
    @my_pets = Pet.where(user_id: current_user.id).order(created_at: :desc)
    render :my_pets
  end

  # GET /pets/1 or /pets/1.json
  def show
  end

  # GET /pets/new
  def new
    @pet = Pet.new
  end

  # GET /pets/1/edit
  def edit
  end

  # POST /pets or /pets.json
  def create
    @pet = Pet.new(pet_params)
    @pet.user_id = current_user.id 

    respond_to do |format|
      if @pet.save
        format.html { redirect_to pet_url(@pet), notice: "Pet was successfully created." }
        format.json { render :show, status: :created, location: @pet }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pets/1 or /pets/1.json
  def update
    respond_to do |format|
      if params[:pet][:image].present? && params[:pet][:image] != [""]
        @pet.image.attach(params[:pet][:image])
      end
  
      if @pet.update(pet_params)
        format.html { redirect_to pet_url(@pet), notice: "Pet was successfully updated." }
        format.json { render :show, status: :ok, location: @pet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pets/1 or /pets/1.json
  def destroy
    @pet.destroy!

    respond_to do |format|
      format.html { redirect_to pets_url, notice: "Pet was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pet
      @pet = Pet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pet_params
      params.require(:pet).permit(:name, :description, :price, :age, :category, :delivery_to_client, :insuranse, image: []).tap do |whitelisted|
        whitelisted.merge!(params.permit(:category, :sort, :min_price, :max_price, :query, :page))
      end
    end

    def authorize_user
      @pet = Pet.find(params[:id])
      unless @pet.user == current_user
        redirect_to pets_path, alert: "You are not authorized to perform this action."
      end
    end

    def check_seller
      unless current_user.seller?
        redirect_to pets_path, alert: "You must activate your seller account to add or edit pets."
      end
    end
end
