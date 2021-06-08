class UserController < ApplicationController
    def index
        user = User.all
        render json: {
            status: 'Success',
            data: user
        }, status: :ok
    end
end
