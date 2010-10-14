# encoding: utf-8
module MetainfoHelper
  def last_update_msg(obj)
    suffix = (obj.updated_by.blank? ? '' : " by #{obj.updated_by}")
    obj.updated_at.to_s(:db) + suffix
  end
end
