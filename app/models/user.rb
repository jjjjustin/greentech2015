class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :templates
  has_many :ideas, dependent: :destroy
  has_many :responses, dependent: :destroy

  has_one :plan, dependent: :destroy
  has_one :user_profile, dependent: :destroy

  def trial?
    if (DateTime.current <= (self.created_at + 30.days)) || self.admin?
      return true
    else
      return false
    end
  end

  def plan_capacity?
    # allow if still under the trial period or admin
    if self.trial? || self.admin?
      return true
    # check if there is a plan object and if it has capacity
    elsif self.plan
      current_idea_count = self.ideas.count
      current_plan = PlanOption.where(stripe_plan_id: self.plan.plan_id).first

      # if there is a matching plan to what the user has subscribed to
      if current_plan
        current_plan_max = current_plan.idea_max

        # check if the user has reached their limit
        if current_idea_count < current_plan_max
          return true
        else
          return false
        end
      else
        return false
      end

    # if no trial and no plan object
    else
      return false
    end
  end

end
