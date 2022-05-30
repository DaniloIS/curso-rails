class AdminMailerPreview < ApplicationMailer
  def update_email(current_admin, admin)
    AdminMailer.update_email(admin.first, admin.last)
  end
end
