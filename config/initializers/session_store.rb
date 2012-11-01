# Copyright 2011-2012 Rice University. Licensed under the Affero General Public 
# License version 3 or later.  See the COPYRIGHT file for details.

# Be sure to restart your server when you modify this file.

Ost::Application.config.session_store :cookie_store, key: '_ost_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Ost::Application.config.session_store :active_record_store
