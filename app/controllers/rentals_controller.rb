# -*- coding: utf-8 -*-
class RentalsController < ApplicationController

  # TODO: レンタル中の状態から「返却」の概念の仕様考えろ

  # GET /rentals
  # GET /rentals.json
  def index
    @rentals = Rental.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rentals }
    end
  end

  # GET /rentals/1
  # GET /rentals/1.json
  def show
    @rental = Rental.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @rental }
    end
  end

  # GET /rentals/new
  # GET /rentals/new.json
  def new
    @rental = Rental.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @rental }
    end
  end

  # GET /rentals/1/edit
  def edit
    @rental = Rental.find(params[:id])
  end

  def create
    @rental = Rental.new(params[:rental])
    if @rental.save
      redirect_to @rental.book, notice: 'レンタルしました'
    else
      render :controller => :books, :action => :show
    end
  end

  # PUT /rentals/1
  # PUT /rentals/1.json
  def update
    @rental = Rental.find(params[:id])

    respond_to do |format|
      if @rental.update_attributes(params[:rental])
        format.html { redirect_to @rental, notice: 'Rental was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @rental.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rentals/1
  # DELETE /rentals/1.json
  def destroy
    @rental = Rental.find(params[:id])
    @rental.destroy

    respond_to do |format|
      format.html { redirect_to rentals_url }
      format.json { head :no_content }
    end
  end
end
