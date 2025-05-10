class AssistantAssignment < ApplicationRecord
  belongs_to :coach, class_name: 'User'
  belongs_to :assistant, class_name: 'User'
end