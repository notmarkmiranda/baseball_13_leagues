class User < ApplicationRecord
  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable,
         :lockable
end
