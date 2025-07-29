users.defaults password: "Secret1*3*5*"
def users.create(label = nil, unique_by: :email, **, &) = super
