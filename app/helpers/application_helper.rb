module ApplicationHelper
  def flash_class(alert_name)
    {
      'alert' => 'danger',
      'success' => 'success'
    }[alert_name] || 'primary'
  end
end
