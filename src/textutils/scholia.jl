"""True if URN is a scholion's comment.
$(SIGNATURES)
"""
function iscomment(u::CtsUrn)
    endswith(passagecomponent(u), ".comment")
end

"""True if URN is a scholion's lemma.
$(SIGNATURES)
"""
function islemma(u::CtsUrn)
    endswith(passagecomponent(u), ".lemma")
end


"""Find text, if any, of lemma for a scholion.
$(SIGNATURES)
"""
function lemma_text(u::CtsUrn, c::CitableTextCorpus)
    lemma_text(u, c.passages)
end



"""Find text, if any, of lemma for a scholion.
$(SIGNATURES)
"""
function lemma_text(u::CtsUrn, v::Vector{CitablePassage})
    psgs = filter(scholion(u, v)) do psg
        islemma(urn(psg)) && ! isempty(text(psg))
    end
    isempty(psgs) ? "" : text(psgs[1])
end

function lemma_text(p::CitablePassage)
    islemma(urn(p)) ? text(p) : ""
end



function comment_text(p::CitablePassage)
    iscomment(urn(p)) ? text(p) : ""
end

"""Find text of comment for a scholion.
$(SIGNATURES)
"""
function comment_text(u::CtsUrn, c::CitableTextCorpus)
    comment_text(u, c.passages)
end

"""Find text of comment for a scholion.
$(SIGNATURES)
"""
function comment_text(u::CtsUrn, v::Vector{CitablePassage})
    psgs = filter(scholion(u, v)) do psg
        iscomment(urn(psg))
    end
    isempty(psgs) ? "" :  text(psgs[1])
end


"""Find scholia passages matching URN.
$(SIGNATURES)
"""
function scholion(u::CtsUrn, v::Vector{CitablePassage})
    # Ignore version/exemplar of scholion in this comparison:
    generic = dropversion(u)

    # Subsequent URN matching faster if we preselect
    # for scholia:
    schpsgs = filter(v) do psg
        groupid(urn(psg)) ==  "tlg5026"
    end

    filter(schpsgs) do psg
        reduced = dropversion(collapsePassageBy(urn(psg), 1))
        reduced == generic
    end
end

"""Find scholia passages matching URN.
$(SIGNATURES)
"""
function scholion(u::CtsUrn, c::CitableTextCorpus)
    scholion(u, c.passages)
end



"""Find text of scholia passages matching URN.
$(SIGNATURES)
"""
function scholion_text(u::CtsUrn, v::Vector{CitablePassage})
    join(text.(scholion(u, v)), " ") |> strip

end


"""Find text of scholia passages matching URN.
$(SIGNATURES)
"""
function scholion_text(u::CtsUrn, c::CitableTextCorpus)
    scholion_text(u, c.passages)
end


"""Format text of a single scholion in Markdown.
$(SIGNATURES)
"""
function scholion_text_md(v::Vector{CitablePassage})
    lemm = lemma_text.(v)
    comm = comment_text.(v)
    isempty(lemm) ? comm : "**$(lemm)** $(comm)"
end

"""Format text of scholia passages matching URN as Markdown.
$(SIGNATURES)
"""
function scholion_text_md(u::CtsUrn, v::Vector{CitablePassage})
   lemm = lemma_text(u, v)
   comm = comment_text(u,v)
   isempty(lemm) ? comm : "**$(lemm)** $(comm)"
end


"""Format text of scholia passages matching URN as Markdown.
$(SIGNATURES)
"""
function scholion_text_md(u::CtsUrn, c::CitableTextCorpus)
    scholion_text_md(u, c.passages)
end

"""Find scholia passages commenting on a given URN.
$(SIGNATURES)
"""
function scholia_on(iliad::CtsUrn, c::CitableTextCorpus, idx::CitableCommentary)
    scholia_on(iliad, c.passages, idx)
end



"""Find scholia passages commenting on a given URN.
$(SIGNATURES)
"""
function scholia_on(iliad::CtsUrn, v::Vector{CitablePassage}, idx::CitableCommentary)
    matches = filter(pr -> pr[2] == iliad, idx.commentary) 
    scholia = map(pr -> pr[1], matches)
    map(scholia) do sch
        scholion(sch, v)
    end
end


function scholia_text_on(iliad::CtsUrn, c::CitableTextCorpus, idx::CitableCommentary)
    scholia_text_on(iliad, c.passages, idx)
end


function scholia_text_on(iliad::CtsUrn, v::Vector{CitablePassage}, idx::CitableCommentary)
    matches = filter(pr -> pr[2] == iliad, idx.commentary) 
    scholia = map(pr -> pr[1], matches)
    map(scholia) do sch
        scholion_text(sch, v)
    end
end