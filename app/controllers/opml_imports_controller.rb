class OpmlImportsController < ApplicationController
  before_action :authenticate

  layout "forms"

  def new
  end

  def create
    opml_import = OpmlImport.create!(opml_import_params)
    ImportOpmlJob.perform_later(opml_import, Current.user)
    redirect_to root_path, notice: t(".success")
  end

  private

  def opml_import_params
    params.require(:opml_import).permit(:file)
  end
end
