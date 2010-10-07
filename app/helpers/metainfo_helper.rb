# encoding: utf-8
module MetainfoHelper
  def last_update_msg(obj)
    last_username = obj.last_updater_name
    suffix = (last_username.blank? ? '' : " by #{last_username}")
    obj.updated_at.to_s(:db) + suffix
  end
end
