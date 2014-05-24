# This class holds a stupid simple authentication logic for
# the Admin dashboard.
#
# TODO: Maybe refactor this in the future to something more
# generic.
# This is a very naive implementation that fits only the
# admin panel authorization model.
class Permission < Struct.new(:user)
  def allow?
    !!user && user.admin?
  end
end
