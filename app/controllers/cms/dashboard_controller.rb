# -*- encoding : utf-8 -*-
class Cms::DashboardController < Cms::BaseController
  
  def index
    @users_count = User.where(type_cd: [:guest, :member]).count
    @guests_count = User.guests.count
    @unactivated_members_count = User.members.unactivated.count
    @activated_members_count = User.members.activated.count
    @ten_days_users_count = User.recently(10.days).count
    @ten_days_guests_chart = (10).downto(1).map{|i| Time.now - i.days}.map{|day| [day.strftime('%m/%d'), User.guests.where('signed_up_at >= ?', day.beginning_of_day).where('signed_up_at <= ?', day.end_of_day).count]}
    @ten_days_members_chart = (10).downto(1).map{|i| Time.now - i.days}.map{|day| [day.strftime('%m/%d'), User.members.where('signed_up_at >= ?', day.beginning_of_day).where('signed_up_at <= ?', day.end_of_day).count]}
  end
end