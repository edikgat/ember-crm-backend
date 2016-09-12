ActiveAdmin.register SupportRequest do
  permit_params :subject, :user_id, :status, :notes

  form do |f|
    f.inputs "Support Request Details" do
      f.input :subject
      f.input :user, collection: User.all.map {|u| [u.email, u.id]}
      f.input :status, as: :select, collection: SupportRequest::AVALIABLE_STATUSES
      f.input :notes
    end
    f.actions
  end

end
