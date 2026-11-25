class RiskMailer < Mailer
  def risk_notification(risk, recipient)
    @risk = risk
    @project = risk.project
    @recipient = recipient
    @risk_url = url_for(controller: 'risks', action: 'show', id: risk.id, project_id: @project.id)

    mail to: recipient.mail,
         subject: "[#{@project.name} - #{l(:label_risk)} ##{@risk.id}] (#{@risk.risk_status.name}) #{@risk.title}"
  end

  def self.deliver_risk_notification(risk)
    recipients = risk.notified_users
    recipients.each do |user|
      risk_notification(risk, user).deliver_later if user.mail.present?
    end
  end
end
