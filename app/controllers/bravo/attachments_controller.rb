class Bravo::AttachmentsController < Bravo::BaseController
  def destroy
    resource_class = Bravo.resource_for(params[:resource_name]) or raise ActiveRecord::RecordNotFound
    record = resource_class.model_class.find(params[:id])
    authorize record, :update?

    attachment = ActiveStorage::Attachment.find_by!(id: params[:attachment_id], record:)
    attachment.purge_later

    redirect_back fallback_location: bravo_resource_path(params[:resource_name], record), notice: "File removed."
  end
end
