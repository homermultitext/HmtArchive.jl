
### THESE SHOULD GO IN CitableText
"""Extract work ID value from a Cts Urn.
"""
function textid(u::CtsUrn)
    workparts(u)[2]
end

"""Extract version ID value from a Cts Urn.
"""
function versionid(u::CtsUrn)
	workparts(u)[3]
end

