var express = require('express');
var axios = require('axios');
var router = express.Router();

// Global data store
const store = {

  config: {
    port: 8000
  },

  eloqua: {
    appUrl: 'https://secure.p04.eloqua.com/api/REST/2.0/',
    bulkUrl: 'https://secure.p04.eloqua.com/api/bulk/2.0/'
  },

};

/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send('API is running');
});

// Verify Eloqua credentials
router.get('/check-auth', (req, res) => {
  // Get Authorization header from request
  const auth = req.headers.authorization;
  // Fetch Eloqua user from API to verify credentials
  axios({
    url: store.eloqua.appUrl + 'system/user/current',
    method: 'GET',
    headers: {
      'Authorization': auth
    }
  })
    .then((resp) => {
      if (resp.status === 200) {
        // Credentials are valid
        res.status(200).json(resp.data);
      } else {
        res.status(401).json(resp.data);
      }
    })
    .catch((error) => {
      res.status(500).send("An error occurred: " + error);
    });
});

// Retrieve emails
router.get('/assets/emails', (req, res) => {
  // Get Authorization header from request
  const auth = req.headers.authorization;
  // Fetch Eloqua user from API to verify credentials
  axios({
    url: store.eloqua.appUrl + 'assets/emails?depth=complete',
    method: 'GET',
    headers: {
      'Authorization': auth
    }
  })
    .then((resp) => {
      res.status(resp.status).json(resp.data);
    })
    .catch((error) => {
      res.status(500).send("An error occurred: " + error);
    });
});

// Update an email
router.put('/assets/emails/:id', (req, res) => {
  // Get Authorization header from request
  const auth = req.headers.authorization;
  // Get email id parameter
  const id = req.params.id;
  if (!id) {
    res.status(400).send("Invalid parameter received for email id");
  }
  // Get updated email from request body
  const email = req.body;
  // Fetch Eloqua user from API to verify credentials
  axios.put(store.eloqua.appUrl + 'assets/email/' + id,
    email,
    {
      headers: {
        'Authorization': auth
      }
    }
  )
    .then((resp) => {
      res.status(resp.status).json(resp.data);
    })
    .catch((error) => {
      if (error.response) {
        res.status(error.response.status).json(error.response.data);
      } else {
        res.status(500).send("An error occurred: " + error.message);
      }
    });
});

// Retrieve landing pages
router.get('/assets/landing-pages', (req, res) => {
  // Get Authorization header from request
  const auth = req.headers.authorization;
  // Fetch Eloqua user from API to verify credentials
  axios({
    url: store.eloqua.appUrl + 'assets/landingPages?depth=complete',
    method: 'GET',
    headers: {
      'Authorization': auth
    }
  })
    .then((resp) => {
      res.status(resp.status).json(resp.data);
    })
    .catch((error) => {
      res.status(500).send("An error occurred: " + error);
    });
});

// Update a landing page
router.put('/assets/landing-pages/:id', (req, res) => {
  // Get Authorization header from request
  const auth = req.headers.authorization;
  // Get landing page id parameter
  const id = req.params.id;
  if (!id) {
    res.status(400).send("Invalid parameter received for landing page id");
  }
  // Get updated landing page from request body
  const page = req.body;
  // Fetch Eloqua user from API to verify credentials
  axios.put(store.eloqua.appUrl + 'assets/landingPage/' + id,
  page,
    {
      headers: {
        'Authorization': auth
      }
    }
  )
    .then((resp) => {
      res.status(resp.status).json(resp.data);
    })
    .catch((error) => {
      if (error.response) {
        res.status(error.response.status).json(error.response.data);
      } else {
        res.status(500).send("An error occurred: " + error.message);
      }
    });
});

// Retrieve headers
router.get('/assets/headers', (req, res) => {
  // Get Authorization header from request
  const auth = req.headers.authorization;
  // Fetch Eloqua user from API to verify credentials
  axios({
    url: store.eloqua.appUrl + 'assets/email/headers?depth=complete',
    method: 'GET',
    headers: {
      'Authorization': auth
    }
  })
    .then((resp) => {
      res.status(resp.status).json(resp.data);
    })
    .catch((error) => {
      res.status(500).send("An error occurred: " + error);
    });
});

// Update a header
router.put('/assets/headers/:id', (req, res) => {
  // Get Authorization header from request
  const auth = req.headers.authorization;
  // Get header id parameter
  const id = req.params.id;
  if (!id) {
    res.status(400).send("Invalid parameter received for header id");
  }
  // Get updated header from request body
  const page = req.body;
  // Fetch Eloqua user from API to verify credentials
  axios.put(store.eloqua.appUrl + 'assets/email/header/' + id,
  page,
    {
      headers: {
        'Authorization': auth
      }
    }
  )
    .then((resp) => {
      res.status(resp.status).json(resp.data);
    })
    .catch((error) => {
      if (error.response) {
        res.status(error.response.status).json(error.response.data);
      } else {
        res.status(500).send("An error occurred: " + error.message);
      }
    });
});

// Retrieve footers
router.get('/assets/footers', (req, res) => {
  // Get Authorization header from request
  const auth = req.headers.authorization;
  // Fetch Eloqua user from API to verify credentials
  axios({
    url: store.eloqua.appUrl + 'assets/email/footers?depth=complete',
    method: 'GET',
    headers: {
      'Authorization': auth
    }
  })
    .then((resp) => {
      res.status(resp.status).json(resp.data);
    })
    .catch((error) => {
      res.status(500).send("An error occurred: " + error);
    });
});

// Update a footer
router.put('/assets/footers/:id', (req, res) => {
  // Get Authorization header from request
  const auth = req.headers.authorization;
  // Get footer id parameter
  const id = req.params.id;
  if (!id) {
    res.status(400).send("Invalid parameter received for footer id");
  }
  // Get updated footer from request body
  const page = req.body;
  // Fetch Eloqua user from API to verify credentials
  axios.put(store.eloqua.appUrl + 'assets/email/footer/' + id,
  page,
    {
      headers: {
        'Authorization': auth
      }
    }
  )
    .then((resp) => {
      res.status(resp.status).json(resp.data);
    })
    .catch((error) => {
      if (error.response) {
        res.status(error.response.status).json(error.response.data);
      } else {
        res.status(500).send("An error occurred: " + error.message);
      }
    });
});

// Retrieve content
router.get('/assets/content', (req, res) => {
  // Get Authorization header from request
  const auth = req.headers.authorization;
  // Fetch Eloqua user from API to verify credentials
  axios({
    url: store.eloqua.appUrl + 'assets/contentSections?depth=complete',
    method: 'GET',
    headers: {
      'Authorization': auth
    }
  })
    .then((resp) => {
      res.status(resp.status).json(resp.data);
    })
    .catch((error) => {
      res.status(500).send("An error occurred: " + error);
    });
});

// Update content
router.put('/assets/content/:id', (req, res) => {
  // Get Authorization header from request
  const auth = req.headers.authorization;
  // Get content id parameter
  const id = req.params.id;
  if (!id) {
    res.status(400).send("Invalid parameter received for content id");
  }
  // Get updated content from request body
  const page = req.body;
  // Fetch Eloqua user from API to verify credentials
  axios.put(store.eloqua.appUrl + 'assets/contentSection/' + id,
  page,
    {
      headers: {
        'Authorization': auth
      }
    }
  )
    .then((resp) => {
      res.status(resp.status).json(resp.data);
    })
    .catch((error) => {
      if (error.response) {
        res.status(error.response.status).json(error.response.data);
      } else {
        res.status(500).send("An error occurred: " + error.message);
      }
    });
});

module.exports = router;
