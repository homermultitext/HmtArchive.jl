#= 
=#
using Pkg
Pkg.activate(joinpath(pwd(), "dashboard"))
Pkg.resolve()
Pkg.instantiate()

DASHBOARD_VERSION = "0.1.0"

using Dash
using CitableBase
using CitableText
using CitableCorpus
using CitableObject
using CitableImage
using CitablePhysicalText
using HmtArchive, HmtArchive.Analysis

#using Orthography


THUMBHEIGHT = 200
TEXTHEIGHT = 600



function loaddata()
    src = hmt_cex()
    dse = hmt_dse(src)[1]
    normed = hmt_normalized(src)
    info = hmt_releaseinfo(src)

    (dse, normed, release)
end

(dsec, corpus, release) = loaddata()


function surfacemenu(triples, mschoice)
    menupairs = []
    mstriples = filter(tr -> collectionid(tr.surface) == mschoice, triples)
    mssurfaces = map(tr -> tr.surface, mstriples)
    uniquesurfs =  mssurfaces .|> string |> unique .|> Cite2Urn
    for surf in uniquesurfs
        lbl = objectcomponent(surf)
        push!(menupairs, (label=lbl, value=string(surf)))
    end
    menupairs
end


function msmenu(triples)
    menupairs = []
    sigla = map(tr -> collectionid(tr.surface), triples)  |> unique
    for siglum in sigla
        push!(menupairs, (label=siglum, value=siglum))
    end
    menupairs
end

assetfolder = joinpath(pwd(), "dashboard", "assets")
app = dash(assets_folder = assetfolder, include_assets_files=true)

app.layout = html_div(className = "w3-container") do
    html_div(className = "w3-container w3-light-gray w3-cell w3-mobile w3-border-left  w3-border-right w3-border-gray", children = [dcc_markdown("*Dashboard version*: **$(DASHBOARD_VERSION)** ([version notes](https://homermultitext.github.io/dashboards/alpha-search/))")]),
    
    html_h1("HMT project: DSE verification dashboard"),
    dcc_markdown("Validate and verify content of **$(release)**."),
   
    html_div(className = "w3-container",
        children = [
       
            html_div(className = "w3-col l4 m4 s12",
                children = [
                dcc_markdown("*Choose a manuscript*:"),
                dcc_dropdown(id = "mschoice",
                    options=msmenu(dsec.data))
                ]
                ),             

        html_div(className = "w3-col l4 m4 s12",
        children = [
            dcc_markdown("*Choose a surface*:"),
            dcc_dropdown(id = "surfacepicker")
        ]),
      
        html_div(className = "w3-col l4 m4 s12",
        children = [
            dcc_markdown("*Texts to verify*:")
            dcc_dropdown(
                id = "texts",
                options = [
                    (label = "All texts", value = "all"),
                    (label = "Iliad only", value = "Iliad"),
                    (label = "scholia only", value = "scholia")
                ],
                value = "all",
                clearable=false
            )
        ]),
       
        ]
    ),

    html_div(id="dsecompleteness", className="w3-container"),
    html_div(id="dseaccuracy", className="w3-container")#,

end

callback!(app,
    Output("surfacepicker", "options"),
    Input("mschoice", "value"),
    prevent_initial_call=true
) do siglum
    surfacemenu(dsec.data, siglum)
end



function hmtdse(triples, surf, ht, textfilter)
    baseurl = "https://www.homermultitext.org/iipsrv"
	root = "/project/homer/pyramidal/deepzoom"
	
    iiif =  IIIFservice(baseurl, root)
    ict =  "https://www.homermultitext.org/ict2/?"


    #triples = dsetriples(edrep, strict = false)
    surfacetriples = filter(row -> urncontains(surf, row.surface), triples)
    textsurfacetriples = surfacetriples
    if textfilter == "Iliad"
        textsurfacetriples = filter(row -> urncontains(CtsUrn("urn:cts:greekLit:tlg0012.tlg001:"), row.passage), surfacetriples)
    elseif textfilter == "scholia"
        textsurfacetriples = filter(row -> urncontains(CtsUrn("urn:cts:greekLit:tlg5026:"), row.passage), surfacetriples)
    end
    images = map(tr -> tr.image, textsurfacetriples)
    ictlink = ict * "urn=" * join(images, "&urn=")
    imgmd = markdownImage(dropsubref(images[1]), iiif; ht = ht)
    verificationlink = string("[", imgmd, "](", ictlink, ")")

    
    hdr = "## Visualizations for verification: page *$(objectcomponent(surf))*; texts included: *$(textfilter)*\n\n### Completeness\n\nThe image is linked to the HMT Image Citation Tool where you can verify the completeness of DSE indexing.\n\n"

    hdr * verificationlink
    

end

#=

function hmtdseaccuracy(edrep, surf, height, textfilter)
    iiif = EditorsRepo.DEFAULT_IIIF
    ict = EditorsRepo.DEFAULT_ICT
    surfprs = surfacevizpairs(edrep, surf, strict = false)
    corpus = diplomaticcorpus(edrep)
    #psgs = filter(psg -> urncontains(pr[1], psg.urn), corpus.passages)
    #
    vizprs = surfprs
    if textfilter == "Iliad"
        vizprs = filter(pr -> urncontains(CtsUrn("urn:cts:greekLit:tlg0012.tlg001:"), pr[1]),  surfprs)
    elseif textfilter == "scholia"
        vizprs = filter(pr -> urncontains(CtsUrn("urn:cts:greekLit:tlg5026:"), pr[1]),  surfprs)
    end

    textlines = ["### Accuracy"]
    for pr in vizprs
        # get text contents
        psgs = filter(psg -> urncontains(pr[1], psg.urn), corpus.passages)
        psgtext = if isempty(psgs)
            @warn("No passages match indexed URN $(pr[1])")
            ""
        elseif length(psgs) != 1
            @warn("Found $(length(psgs)) passages matching indexed URN $(pr[1])")
            @warn("Type of first is $(typeof(psgs[1]))")
            textcontent = map(p -> p.text, psgs)
            join(textcontent, "\n")
        else
            psgs[1].text
        end

        mdtext = string("**", passagecomponent(pr[1]), "** ", psgtext, "\n" )
        # get image markup
        mdimg = linkedMarkdownImage(ict, pr[2], iiif; ht=height, caption="image")
        push!(textlines, "---\n\n" * mdimg * "\n\n" * mdtext )
    end
    join(textlines, "\n")
    #"Hi. Filter texts for accuracy, too, just like completeness."
end

# Update surfaces menu and user message when "Load/update data" button
# is clicked:
callback!(
    updaterepodata,
    app,
    Output("datastate", "children"),
    Output("surfacepicker", "options"),
    Input("load_button", "n_clicks"),
    prevent_initial_call=true
)
=#

# Update validation/verification sections of page when surface is selected:
callback!(
    app,
    Output("dsecompleteness", "children"),
    Output("dseaccuracy", "children"),
    Input("surfacepicker", "value"),
    Input("texts", "value")
) do newsurface, txt_choice
    if isnothing(newsurface) || isempty(newsurface)
        (dcc_markdown(""), dcc_markdown(""))#, dcc_markdown(""))
    else
        surfurn = Cite2Urn(newsurface)
        completeness = dcc_markdown(hmtdse(dsec.data, surfurn, THUMBHEIGHT, txt_choice))
       
       
   

        accuracyhdr = "### Verify accuracy of indexing\n*Check that the diplomatic reading and the indexed image correspond.*\n\n"
       
        accuracy = "" #hmtdseaccuracy(r,surfurn, TEXTHEIGHT, txt_choice) |> dcc_markdown
      
        (completeness, accuracy)
    end
end


run_server(app, "0.0.0.0", 8051, debug=true)