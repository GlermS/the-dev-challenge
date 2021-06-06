class Purchase < ApplicationRecord
    validates :purchaser_name, presence: true
    validates :item_price, presence: true
    validates :purchase_count, presence: true
    
    belongs_to :user
end
