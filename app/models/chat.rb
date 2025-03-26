class Chat < ApplicationRecord
    validates :prompt, presence: true
    
    # Add a scope for recent chats
    scope :recent, -> { order(created_at: :desc).limit(50) }
    
    # Optional: Add a method to truncate long conversations
    def self.cleanup_old_chats
      where('created_at < ?', 1.week.ago).delete_all
    end
  end