class Event < ApplicationRecord
    validates :name, presence: true, length: { in: 3..100 },
                     format: { with: /\A[a-zA-Z0-9\s]+\z/, message: "only allows letters, numbers, and spaces" }
    validates :date, presence: true
    validates :description, presence: true, length: { maximum: 500 }
    validate :date_is_not_in_the_past
  
    before_save :adjust_event_date
    before_validation :normalize_name
    after_save :log_event_creation
    after_create :send_welcome
  
    scope :added_in_last_30_days, -> { where('created_at >= ?', 30.days.ago) }
    scope :in_next_week, -> {
      start_of_next_week = Date.current.beginning_of_week + 1.week
      end_of_next_week = start_of_next_week.end_of_week
      where(date: start_of_next_week..end_of_next_week)
    }
  
    private
  
    def date_is_not_in_the_past
      errors.add(:date, "cannot be in the past") if date.present? && date < Date.today
    end
  
    def adjust_event_date
      self.date = date.beginning_of_day if date.present?
    end
  
    def normalize_name
      self.name = name.strip.titleize if name.present?
    end
  
    def log_event_creation
      Rails.logger.info "Event '#{name}' created successfully at #{created_at}."
    end
  
    def send_welcome
      Rails.logger.info "Sending welcome message for the new event '#{name}'."
    end
  end
  