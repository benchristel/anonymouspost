class IndexController < ApplicationController
  def show
    respond_to do |format|
      format.html # index.html.erb
    end
  end
end
